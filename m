Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbZEKWp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbZEKWp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZEKWpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:45:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZEKWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:45:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=IVB4m6GuZg2QRwjLhZncHXOtzhB7VWrAjdCb7db980uP1pXuGH0/5LwKtoyTSfQej
	yiiocaKd1YDbS4HVByPAQ==
Date: Mon, 11 May 2009 15:45:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       San Mehat <san@android.com>, linux-kernel@vger.kernel.org
Subject: [patch 0/4] staging: android lowmemorykiller fixes and cleanup
Message-ID: <alpine.DEB.2.00.0905111539500.5533@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Please consider merging these Android fixes for the staging tree, which 
supercede the same patches posted in a larger set of VM changes from May 
10.
