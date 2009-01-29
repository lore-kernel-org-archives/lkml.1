Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZA2QMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZA2QMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZA2QMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:12:07 -0500
Received: from n1b.bullet.mail.ac4.yahoo.com ([76.13.13.71]:43217 "HELO
	n1b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751940AbZA2QMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:12:06 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 522466.44597.bm@omp102.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=3lWyUW7KyOldep9iyakp58hKtkfCgGb/8t7XfVvTFtVjiuuj4H7PYfJy3GfrhNv6QPFFoqZPt2B2O6v3XNlyFtpxrJyo3YNRZYdUsXQTsom9yscnyfTJRB94uwfJQ4YFfVYI5gMsLdCbEN+JOJJu/mEWAUdmiMvc0mntU25FZak=;
X-YMail-OSG: xhNSrfUVM1np2hiMBEI8rGZ8b_OHEh_5Qb3nCfXvN5.HEx8BPLwdk99HLTDLrqepwFNf8mK2aqZoS.2ACXbGRfx.khRKJX17PA3mSczXAFK5w6dDq25YGwn2bvyAlbbqg02P1EANHxPwYxbn5UzyJUk48doVaTCW8sKMXZMow1FE_QDopN1a3bHfSS.UyEgnp6ZSWClcwyAN8PBHkEo-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 29 Jan 2009 08:12:05 -0800 (PST)
From: Xiaoning Ding <dingxn@ymail.com>
Reply-To: dingxn@ymail.com
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090127132333.2e2d4dcf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <314817.91186.qm@web59911.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not trying to save energy. I want to do some experiments that requires lower CPU speed. But the experiments are not energy related. 

Xiaoning

--- On Tue, 1/27/09, Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@infradead.org>
> Subject: Re: a question about p4_clockmod module on Xeon quad core processors
> To: dingxn@ymail.com
> Cc: linux-kernel@vger.kernel.org
> Date: Tuesday, January 27, 2009, 9:23 PM
> On Tue, 27 Jan 2009 12:17:25 -0800 (PST)
> Xiaoning Ding <dingxn@ymail.com> wrote:
> 
> > Hi list,
> > 
> > I have tried the p4-clockmod module in Linux kernel
> 2.6.29 on Xeon
> > 5355 quad-core CPUs with no luck. It seems current
> p4-clockmod driver
> > still cannot support Intel Quad core processors,
> right? 
> 
> you know that using clockmod will actually cost you energy
> rather than
> saving it right?
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org


      

