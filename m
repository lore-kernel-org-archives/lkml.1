Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXIZIoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXIZIoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXIZIn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:43:57 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:44855 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXIZIn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:43:56 -0400
In-Reply-To: <200709251642.41480.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] ibmebus: Move to of_device and of_platform_driver, match
 eHCA and eHEA drivers
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF1983365C.5CA77642-ONC1257362.002F6D8C-C1257362.002FF658@de.ibm.com>
Date: Wed, 26 Sep 2007 10:43:52 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 26/09/2007 10:43:52,
	Serialize complete at 26/09/2007 10:43:52
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote on 25.09.2007 16:42:40:

> This is missing a description,

The description is "ibmebus: Move to of_device and of_platform_driver, 
match eHCA and eHEA drivers" -- I thought that should be enough since the 
patch is rather straightforward. I can add a more detailed description, 
though. Revised patch will follow.

> but the patch looks good.

Thanks =)

Joachim
