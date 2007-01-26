Return-Path: <linux-kernel-owner+w=401wt.eu-S965527AbXAZNCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbXAZNCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965619AbXAZNCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:02:15 -0500
Received: from web52914.mail.yahoo.com ([206.190.49.24]:21263 "HELO
	web52914.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965623AbXAZNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:02:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Xvf+oTsA1cIF+xZf2lcLOa0AeyVKkSbfctQrP5drtbX+o3/bvLeslSTIwo3QOYpaVWmRo02jTekbkHJ+TTidTajQqcbnlku1cAlnLPRZeTNn4XnsykOu9ttBFn62I3tOfiTMwGXBQC3cJ9BM37LoGEHwrrcF3Q4bgIGVnxSgY4A=  ;
Message-ID: <20070126130213.50355.qmail@web52914.mail.yahoo.com>
X-YMail-OSG: 3XrbX7oVM1kZ1KIydn2IX279.Fo1EN6jTc8APIBaAmYXsytsRFTmYrpEjJaJrX_o05psGC.JB42_3Y_F79Dp9erYOKrMpCdcYGufwJDCtMwgrCDzQHjzP4WfPkLv_Q4AlKhkyN9p7SPlJYvRrZK_ZjSuv9Y5ZBkOZp9df8oAcMWSgcowHFXZiIeCMGSY
Date: Fri, 26 Jan 2007 13:02:13 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.18-stable release plans?
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20070125193644.GA12624@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Ken Moffat <zarniwhoop@ntlworld.com> wrote:
>  I can't, but Dave Jones had a similar problem earlier this month,
> archived at http://uwsg.iu.edu/hypermail/linux/kernel/0701.0/1822.html
> which I think is a followup from
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg105370.html
>  - and seems to be a possible hardware failure (bulging capacitors)
> becoming apparent under load.

Interesting, although I don't believe I have a hardware fault. The box is perfectly stable under
2.6.18.x. Anyway, my particular problem happened very quickly last time so I am hoping that
recompiling xine from scratch will trigger something again. This time, however, I have built a
2.6.19.x kernel with a few memory debugging options turned on.

Cheers,
Chris


		
___________________________________________________________ 
Copy addresses and emails from any email account to Yahoo! Mail - quick, easy and free. http://uk.docs.yahoo.com/trueswitch2.html
