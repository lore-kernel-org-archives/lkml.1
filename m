Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbXFLHvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbXFLHvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbXFLHve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:51:34 -0400
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:30928 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753739AbXFLHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:51:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dj8+nfT29T6Qyp5NszCirExYwSoAYtq5mBG/yaRuYL6utsQ/AmxgkqEj96Rfz5/Ie8bfy/axEbcovliiRcFZL0ylIjLHG4swye9RKE3zTeuZd6SiVswG3XX5aNEoQD85c46JP0m6DB3h3qFPN0lGDxyguBdpyVYAFIYGDi0jwhw=;
X-YMail-OSG: EswrZL8VM1mABO5lzgvjTB.lE81nnT1mKWwcpl6GPEfOGNBltRPsJDD4EIRl9S8OdJSVf74l56J6bRmqPBGm7FlXEk.EqMG1YkP.3a0BySK_jeuyz9E-
Date: Tue, 12 Jun 2007 08:51:32 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.21.5
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <634879.13763.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't this patch from Tejun be applied to 2.6.21.x as well as 2.6.20.x?

Tejun Heo (2):
      ...
      driver-core: don't free devt_attr till the device is released

Cheers,
Chris




      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
