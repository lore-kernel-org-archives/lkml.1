Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYD0IOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYD0IOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYD0IOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:14:05 -0400
Received: from p5082C517.dip.t-dialin.net ([80.130.197.23]:64962 "EHLO
	stiffy.osknowledge.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752052AbYD0IOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:14:03 -0400
X-Greylist: delayed 993 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 04:14:03 EDT
Date: Sun, 27 Apr 2008 09:57:26 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: [GIT / ALSA] Sound muted until PCM value changed
Message-ID: <20080427075726.GA3620@stiffy.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux stiffy 2.6.25-marc-44157-gb1721d0
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

with my latest GIT from yesterday (b1721d0), ALSA sound is muted until I
change the PCM value. The values are correctly restored on boot but one cannot
hear any sound.

Does anyone have similar problems?

Regards,
Marc

-- 
Marc Koschewski
