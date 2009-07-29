Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbZG2NtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbZG2NtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZG2NtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:49:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZG2NtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:49:14 -0400
Message-ID: <4A705359.9060105@suse.de>
Date: Wed, 29 Jul 2009 15:49:13 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] kvm/svm: move nested svm state into seperate struct
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-8-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-8-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This makes it more clear for which purpose these members in the vcpu_svm
> exist.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>   

Nice idea!

Acked-by: Alexander Graf <agraf@suse.de>

