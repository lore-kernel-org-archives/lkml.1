Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZG2NaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZG2NaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZG2NaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:30:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:42062 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZG2NaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:30:02 -0400
Message-ID: <4A704ED9.2000604@suse.de>
Date: Wed, 29 Jul 2009 15:30:01 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] kvm/svm: copy only necessary parts of the control
 area on vmrun/vmexit
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-6-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-6-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>   

What's the reason behind this?

Acked-by: Alexander Graf <agraf@suse.de>

