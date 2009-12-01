Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZLAQKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZLAQKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZLAQKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:10:04 -0500
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:23647 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752839AbZLAQKD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:10:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=nQ+q/B5M1Wiw1/2JpGvKiOiui029SPCPsEuFnOaiNmA4ZjFgjGXfHG6VymNgfvVMux3VzUP5oPk0yBskyAdmB6qe0NU4E0rJCKuY4DmTZ1kEjMLyKaVzKw+dAp+kGJvnZ7KWIsr8kiNoq3f4CFAsoTZecaJJaqbgFVdHEFMsmq0=;
Message-ID: <621988.63882.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: MLYUmuYVM1nTxIDTTVO3938g6YMM.HGzNegb1NJMc1cVcJzLNn0pYnj_B5FeWoEy5Ifbiq6b3BXJMzTe9hjL3JzKKfqoxS6JIt8uY2.jBO4rHuxfHm610PGN6i60i_4DPQee6lHKyh8OcMFQTp12B0F3U5qDf_yBURShLnNzqnb_84xH_El_G3x6v1N0d7RGMeiCcvp0qY6bb2Ee47RglelihRf_HzSdQxDGrvN3Hp02AidTW7VdoDBEYOil.lgeLMttsLXH24QPp82_5nZEcYD6jAfCmTDl5Iy8svwyyp426o7.UXjaKdyGG_i.hBzNAUifrlOnj5daflmI7mU9KD7E1.8xbZUlvnmz8u9YYcg8mrk1Linta36YDLsj59R9HzJR
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Tue, 1 Dec 2009 08:10:09 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: XD/smartmedia - how to implement it right?
To: Maxim Levitsky <maximlevitsky@gmail.com>,
       =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       tglx@linutonix.de
In-Reply-To: <20091201082236.GA27691@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 12/1/09, Jörn Engel <joern@logfs.org> wrote:

> From: Jörn Engel <joern@logfs.org>
> Subject: Re: XD/smartmedia - how to implement it right?
> To: "Maxim Levitsky" <maximlevitsky@gmail.com>
> Cc: "Alex Dubov" <oakad@yahoo.com>, "linux-kernel" <linux-kernel@vger.kernel.org>, arnd@arndb.de, tglx@linutonix.de
> Date: Tuesday, December 1, 2009, 12:22 AM
> On Tue, 1 December 2009 01:04:26
> +0200, Maxim Levitsky wrote:
> > 
> > Alex, could you do me a favor, and explain why partial
> block writes
> > don't work?
> > What happens if its done?
> 
> With the Alauda and the limited set of cards I tried they
> work.
> 
> Jörn
> 

It's a bug particular to jmicron controllers.



      
