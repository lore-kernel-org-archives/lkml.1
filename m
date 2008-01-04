Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYADMOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYADMOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYADMOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:14:14 -0500
Received: from main.gmane.org ([80.91.229.2]:58133 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYADMOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:14:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Do people exaggerate in security advisories?
Date: Fri, 04 Jan 2008 13:21:32 +0100
Message-ID: <fll7u3$p02$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4c0ad.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.11) Gecko/20071129 SeaMonkey/1.1.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found this one today:

http://securitytracker.com/alerts/2007/Oct/1018782.html

In the git changelog:

http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=commit;h=ebbeb2c7ac1b00b608390595783
7a271e80b187e

noone leaves any word about privilege escalation.

Is it really possible to get root privileges with this bug or are there 
people who just write "may be used to escalate privileges" near any bug 
which has something to do with "setuid" or "setgid"?

Thanks in advance

CU

Manuel

