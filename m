Return-Path: <linux-kernel-owner+w=401wt.eu-S1423451AbXBHVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423451AbXBHVpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423450AbXBHVpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:45:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:49586 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423447AbXBHVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:45:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sl37vdoZbKpS61686QstkYXpQN4D0BC6VMngtkgOvrv5ssEGMRJZMsj37YiDRn4dptXyZbMfn7MDXib3248b9zdcmMHJPm6r3BzWw6GKuQddrB5Lss6pLKMTMGmO0oGFo2yd+UY3AXK3MYEFOabAMYMLMEDnUYkCpzPvFZwdvdE=
Message-ID: <471decc70702081345ke6e706o7dbf44d14fe12a50@mail.gmail.com>
Date: Thu, 8 Feb 2007 22:45:36 +0100
From: "Mariusz Gniazdowski" <mgniazd@gmail.com>
Reply-To: "Mariusz Gniazdowski" <mgniazd@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: inotify monitoring /proc
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Can inotify monitor /proc? I would like to catch process creation and
deletion events. My first attempts are not succesul.

-- 
Regards
Mariusz
