Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYCaTK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYCaTK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYCaTKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:10:18 -0400
Received: from hs-out-0708.google.com ([64.233.178.240]:42306 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYCaTKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CAA21MKusyHN/qI6dp+q1OfadI/J53EW/9VNKNwG7aUn2MmYJAOri9znvGtHSlLtLMRKmkfVjb2FmeoBgbFafI5/73yeDzS6bySwZt8yc3te5sEiVexp41o6Y+9wx9xq7YsNJz9WGsaFoFor94c9J/lWdld5YZgovX+4EkeIqPA=
Message-ID: <dd18b0c30803311210n95d39bcy22b0ccc8bd1ed71c@mail.gmail.com>
Date: Mon, 31 Mar 2008 19:10:15 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; sorry for not sending a threaded e-mail, I tested echo mem >
/sys/power/state on my macbook pro 15' with all modules loaded i.g.
uvcvideo,fglrx,ath_pci, etc...
and to my amazement it actually worked, instead of a blank screen and
a reboot, the screen appears. The appletouch looses it's scroll
functionality, as well as the bluetooth mighty mouse, wpa_supplicant
seems to not respond, but other than that it works over here ("knock
on wood"); 2.6.25-rc6 did'nt work for me.

-- 
Justin P. Mattock
