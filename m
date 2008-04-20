Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYDTRPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYDTRPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbYDTRPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:15:22 -0400
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:33887 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755531AbYDTRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:15:21 -0400
X-YMail-OSG: j3Ekz24VM1k8agA8owcQkqswI38IIWONnwZeH1T3RoA5DW9cdPd2TXrVgfz_Cv6bww--
X-RocketYMMF: rancidfat
Date: Sun, 20 Apr 2008 10:15:15 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: 2.6.25 Kernel - Problems with capabilities
To: David <david@unsolicited.net>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <480B4E87.4020709@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <46016.36939.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David <david@unsolicited.net> wrote:

> Mike Galbraith wrote:
> > On Sat, 2008-04-19 at 19:43 +0100, David wrote:
> >   
> >> I'm wondering if anyone might be able to help with a capability problem 
> >> I've noticed with .25 My ntp daemon will no longer run as any non-root 
> >> user, and after some investigation it seems that calls to prctl() are 
> >> failing.

Do you have a libcap that reflects the change from 32 capabilities
to 64? You'll be looking for libcap.so.2.06 or thereabouts.




Casey Schaufler
casey@schaufler-ca.com
