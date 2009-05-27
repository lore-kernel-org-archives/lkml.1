Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbZE0I5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbZE0I5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760736AbZE0I5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:57:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45489 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760704AbZE0I5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:57:20 -0400
Message-ID: <4A1D006F.2030501@redhat.com>
Date: Wed, 27 May 2009 11:57:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davide@xmailserver.org,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 1/3] eventfd: export eventfd interfaces for module
 use
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191528.20860.67700.stgit@dev.haskins.net>
In-Reply-To: <20090526191528.20860.67700.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> We want to use eventfd from KVM which can be compiled as a module, so
> export the interfaces.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com

Since Davide has already acked this patch, please include this in the 
signoff section so we don't lose the paperwork.

-- 
error compiling committee.c: too many arguments to function

