Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbZC0Avv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbZC0Avv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933737AbZC0AvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:51:07 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:44241 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933764AbZC0AvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:51:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZoYZ66VhjrMckVws7GJuAdFQhTEc5YAuEZzjtZMb+IVRNQ+CXJkcIwc/YR+txI1qnQzH/4ntzWyYePZVHk4nVV25yMce2CeeUGnmLdOQIMYNqI3snvaUzTUkXk8Gvkht;
Date: Thu, 26 Mar 2009 17:50:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 4/6] drm/i915: Fix lock order reversal in shmem pread
 path.
Message-ID: <20090326175059.33a756af@hobbes>
In-Reply-To: <1238017510-26784-5-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	<1238017510-26784-2-git-send-email-eric@anholt.net>
	<1238017510-26784-3-git-send-email-eric@anholt.net>
	<1238017510-26784-4-git-send-email-eric@anholt.net>
	<1238017510-26784-5-git-send-email-eric@anholt.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 14:45:08 -0700
Eric Anholt <eric@anholt.net> wrote:

> Signed-off-by: Eric Anholt <eric@anholt.net>

Same comments as 3/6...

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
