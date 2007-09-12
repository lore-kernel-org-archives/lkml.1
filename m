Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXILFRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXILFRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXILFRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:17:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:51825 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXILFRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Aj8IE/cTfVYUkRcUrOVWzcVgz/cK8O4KQ3SVa8NDurJBAOHWRVx+Zt9MM6iSxvIlZjhzrI4IIGeFwIz3TvqSGd2G4i/YJ/nk83iEuh3gC6ujAP1w5hodeuUUizmu2apVRCRrpxZA0UUMz1U9NAxkCekczx35xyLAM4D9nAotl0g=
Message-ID: <23eb1e460709112217q3e174de3l1b2539995adec1a0@mail.gmail.com>
Date: Wed, 12 Sep 2007 10:47:17 +0530
From: "sreenath Angadi" <sreenath.angadii@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Query on Real Time Signalling in Linux 2.6.16 kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I would like to use the Real time signalling mechanism. When I try to
use "F_SETAUXFL", compilation fails. While looking through the
archives I found a patch  one-sig-perfd-2.4.4.patch.gz at
http://www.uwsg.iu.edu/hypermail/linux/kernel/0105.2/0642.html which
needs to be applied for the support.
I am using Linux 2.6.16 kernel. So I can't apply this patch directly.
Is there a different patch for this kernel or is the support in built.
If the support is already present, then any pointers on usage(RT
Signalling) would be of great help.

Thanks and Regards,

Sreenath.
