Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022Ab0ASGyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0ASGyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 01:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316Ab0ASGys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 01:54:48 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45719 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab0ASGys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 01:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=nn4wIi/Y3v4GYJQI0/MrUOHoi07JJ/gn100vWVqP97FKblGogpHuOGFbR1QVg8IObE
         01BpG+tDqN7pEiGCsr/hpNTdtBbbp+h/Zpqb4vUeYpbRO2+N209/Z4+X+firxVXFPaRN
         AFWVC2IP86sBM4Pvw5g7jELet3o7tiVjR7G3I=
MIME-Version: 1.0
Date: Tue, 19 Jan 2010 14:54:47 +0800
Message-ID: <4104961b1001182254x74f3fcd1r906de8f10c105f8a@mail.gmail.com>
Subject: Where is proc_misc.c?
From: jidong xiao <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does anybody know what happend to fs/proc/proc_misc.c? The file is
missing in 2.6.29. Seems like there was an cleanup, but i can't find
the new location of the methods. Any help appreciated.

Regards
Jason
