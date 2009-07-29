Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZG2NXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZG2NXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZG2NXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:23:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:41782 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbZG2NXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:23:07 -0400
Message-ID: <4A704D3A.9050901@suse.de>
Date: Wed, 29 Jul 2009 15:23:06 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] kvm/svm: optimize nested #vmexit
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-4-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-4-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> It is more efficient to copy only the relevant parts of the vmcb back to
> the nested vmcb when we emulate an vmexit.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>   

Acked-by: Alexander Graf <agraf@suse.de>

