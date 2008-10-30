Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbYJ3Gjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbYJ3Gjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYJ3Gj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:39:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:20360 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYJ3Gj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=jD3c95sxKYcq4b0fKR5hezfAouk1Ahr5MUGuPM+FtnoAqNpIJqu03WDsfAchMvb5pp
         NwlOBNJjV+lR5DWvx7Vz8U2Mgvi30doLvPZi4N3QUPRyB0C9ZKK9kdFNifUu7vnIaabk
         l5Df3Ny8bPzyB1Djil07Pt7gvhGaXChuUBYYM=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc2 seems to fail at powering down the monitor when it should
Date: Thu, 30 Oct 2008 02:39:18 -0400
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810300239.18842.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;  Subject says it.  When it comes time for the monitor to go 
into standby and powerdown, the on-screen clock I use for the short screen 
saver just stops, frozen, but the monitor is very much alive at normal 
brightness.

2.6.27.1(2/3/4) does this inactivity power down normally.

Any .config options I should check?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Those who hate and fight must stop themselves -- otherwise it is not stopped.
		-- Spock, "Day of the Dove", stardate unknown
