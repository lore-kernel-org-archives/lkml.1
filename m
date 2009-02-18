Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZBRHfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZBRHfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 02:35:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZBRHex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 02:34:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:40556 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZBRHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 02:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Z+wuZPz/QEJfTe/RKpVb/7+xY7AAils7FMC+/npFQKPWl+5G7xLvCGDMDoIb6StxS1
         7+cA5858BOPLxdUqYgkEFIvu0MWlXlrTVLg++ALcxjPn7vDGfe2utUDyEtWFhzOlQmDO
         jM3GGPrVVYhqVGSNrbCJcYyPdO3Dd5N4Jbr3c=
MIME-Version: 1.0
Date: Wed, 18 Feb 2009 15:34:51 +0800
Message-ID: <9b5c9bb30902172334o1ae3951i7daf4de65b428434@mail.gmail.com>
Subject: Reference to inexistent struct dmi_device_id breaks the build into 
	2.6.28-stable
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry if this is not the right place to ask.  I am curious about when
the "Reference to inexistent struct dmi_device_id breaks the build"
(http://bugzilla.kernel.org/show_bug.cgi?id=12483) fix going into
2.6.28-stable tree?  I just checked 2.6.28.6 and it isn't there.

Thanks.

Kindest regards,
Giam Teck Choon
