Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYJ1Uqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYJ1Uqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJ1Uqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:46:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:56808 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYJ1Uqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VZJk/a5XpNgRxk+J5zV+AGjC7DD3Xg2e+b3080sQVNCKR32V4W5v6C4mUbJKImy2Nr
         7rWoZShx7b6i8a8KOLVUwuL2MRYe545c4qgWJSaUUSZ/Vy1NV3pQa75WkpELK0dEIBp3
         tCVWDUqe7n3nmrgyTS2//UA824Kt8c4a4yB5U=
Message-ID: <49077A13.7020603@gmail.com>
Date: Tue, 28 Oct 2008 23:46:11 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
CC: Zhao Yakui <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6.28-rc2] EeePC ACPI errors & exceptions
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>  <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>  <1225186966.5189.143.camel@yakui_zhao.sh.intel.com> <4FFABF28C8%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4FFABF28C8%linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

Please check if the patch 
http://marc.info/?l=linux-acpi&m=122516784917952&w=4
helps.

Thanks,
Alex.


