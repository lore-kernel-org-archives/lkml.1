Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZG2N1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZG2N1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZG2N1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:27:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbZG2N13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:27:29 -0400
Message-ID: <4A704E41.7070805@suse.de>
Date: Wed, 29 Jul 2009 15:27:29 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] kvm/svm: optimize nested vmrun
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-5-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Only copy the necessary parts of the vmcb save area on vmrun and save
> precious time.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>   

Acked-by: Alexander Graf <agraf@suse.de>

