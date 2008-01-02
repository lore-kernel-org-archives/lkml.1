Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYABS1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYABS1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYABS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:27:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:55347 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYABS1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=jK6mssWqXDUQ2VnU9aZgX4UTobuQABAh+9Q9t5MJEpnS9kQyuA300qPwcblvSaKgJN1OPDFXdYdRr1IrWp49blilqaK1mF4kMJIka9IRvq8l3vMoCvWbvZNreLW61c1YgrEnv5JYFagecoU6Hmysm9oxa//VqWm3OuiTrSvUOSQ=
Date: Wed, 2 Jan 2008 19:26:29 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Message-Id: <20080102192629.28e67241.diegocg@gmail.com>
In-Reply-To: <20080102013218.GO27566@does.not.exist>
References: <20080102013218.GO27566@does.not.exist>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 2 Jan 2008 03:32:18 +0200, Adrian Bunk <bunk@kernel.org> escribió:

> It might make sense to offer ext4 in -mm and even in early -rc kernels, 
> but I've already seen people using ext4 simply because a stable kernel 
> offered it - and that's definitely not intended.

But isn't that the whole purpose of having ext4 snapshots in the stable kernel - to
allow people to try it?
