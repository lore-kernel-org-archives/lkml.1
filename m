Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbZLSLkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbZLSLkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 06:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZLSLkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 06:40:42 -0500
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18]:45175 "HELO
	web52908.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750946AbZLSLkl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 06:40:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2GgoxjhIwR4J7HtNZIZEHA1CpMEk/Smj1NZTeRMZKYTwSTnIj4H2pqhb5if1CluWktBq0PtLT6Y0Ok7NxEe3xG6KuRt+AYKVHJNRJU0pp4rFIYYonqu53dZCf93AYUnpW00EOR7ymIGwXYRdX7TNWEJRlkV8+8kEN55mjSivz0c=;
Message-ID: <209510.16318.qm@web52908.mail.re2.yahoo.com>
X-YMail-OSG: .sTAvkkVM1nBpBxCbSKhsPZ8yRCM.6W_JG2K1A9Yoji53FVYF0nkYUK92zphM68DtwgATpVIP4.kZ8oWPtM3f2RsQObkYa.BQ4wVv2HyppRIXyhvVyKzLdGWLcTEpcDLmnfV6AS5uDf4PKbrK3TP.OxKBoRJ4d.4N28aZVBarK3.0DcW00aBkNK5oLXNFfCFDS12pM36CqPOXumwbpEM0MmApi_l_iF9qQ3WlDYuXvp5mSLm5CIZpthzSImH5pjPOnGPMKV7uYqUA9hws3Otg1z.LbFvVqQXs88Ii1IhcsAHHJ1xxZYDwnFh2Xq3Fp74Nzo5DuxObC.CLp15goVDOIt1zQ21Lw--
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Sat, 19 Dec 2009 03:40:40 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Kernel built for i586 chip crashes instantly at boot time (CMOV instructions)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B2BB812.103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 18/12/09, H. Peter Anvin <hpa@zytor.com> wrote:
> Does this patch work for you?

Yes, that fixed it.

Thanks,
Chris


      
