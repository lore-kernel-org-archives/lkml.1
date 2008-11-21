Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYKURXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYKURXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYKURXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:23:17 -0500
Received: from web65612.mail.ac4.yahoo.com ([76.13.9.80]:32055 "HELO
	web65612.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757251AbYKURXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:23:16 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2008 12:23:15 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=HtQcXJOkAaCYQrAITbiqYaPiLPDurVxhRrxaKl5y/Bl756cKgu6LngGP8luIzMHc6s2VcGO/2F/LeGmuwFjG7+6gzKOQmgFm8dfUIWM3WsqEILSIdU/Hp2rKLGSrxLBS+y0I68qP52SKlhTPB+y/9KE4IMDy5kEooOli4uyirW4=;
X-YMail-OSG: NXByzUYVM1lblY805l8lcg3DGoY45It5EwtyJ_GYTp6NCe4Qi0kfyy5jNLhEGS0XdAcUHk4oJ2DkGFHJOsymJPW_1bhgYh7mVeSymZH_FbxXhD4fqVWTW9LkcOj2KVj9Tp9_pfSq6p3lewwg_CET10PjdeAInZn0Ir_pPRw-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Fri, 21 Nov 2008 09:16:33 -0800 (PST)
From: Ryan Mak <tremolo_72@yahoo.com>
Reply-To: tremolo_72@yahoo.com
Subject: pthread and multiple cores
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <890000.99085.qm@web65612.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

working with a multiple core box, there seems to be core(s) idle and not evenly distributed when threads are set(default) with system scope. is this a scheduler thing or am i not tuning my pthread parameters correctly? thanks.



      
