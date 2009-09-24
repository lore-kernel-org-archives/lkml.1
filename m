Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZIXVlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZIXVlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZIXVlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:41:08 -0400
Received: from web65310.mail.ac2.yahoo.com ([68.180.158.236]:36374 "HELO
	web65310.mail.ac2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751941AbZIXVlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:41:08 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 17:41:07 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=Pedf1WxCBEc44N//RE/nzqpBKYi8QbSmPODpgDxiPhJwQo9fyzyUNgvJ1knm7RA/5azWWkWx3LIlBktpl1qRPQwz+81UnkMPqw+7TDP/t5Ug2eNYdaiKE/U96mNLZsPn8hTsWZgJup/Wekpptmacm3s+wk4/EO+08231o4W8III=;
Message-ID: <52335.13812.qm@web65310.mail.ac2.yahoo.com>
X-YMail-OSG: 0TG6OhkVM1mq41W.RBtCAWdQ_icljaPrir9vmw0A0ukXaREbc1lZntzp36KBYZlu_s8b.nyAs3L2WHl7JWsAqZxP2pDoJGN9eaFYiQb9m8HTYtcG4G75mu0ltCQQVx5XRiJd_LBPJsjU_NVFwjhi_J4sWAmGr39RiyxVaRDOu7dLSh9KfKbMQvo3aLLS00bwo2pHlASZtwhZsbi69x8uIjSBVGm8mfPmuJ.OYViYFlCzb.yoqcvX4IZ.py5Wn0TGk.t28MLiitXFChTyBbGC
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.2
Date: Thu, 24 Sep 2009 14:34:29 -0700 (PDT)
From: Andrew Randrianasulu <randrik_a@yahoo.com>
Subject: Re: disk speed regression kernel 2.6.29 and after
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Myself still using old IDE subsystem, not libata on my main box. Recently i saw something like http://lkml.org/lkml/2009/9/19/288 - i will try to switch my .config over libata stuff and watch for disk performance.


      
