Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbZG2OP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbZG2OP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZG2OP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:15:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:44153 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZG2OPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:15:55 -0400
Message-ID: <4A70599A.3030804@suse.de>
Date: Wed, 29 Jul 2009 16:15:54 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] kvm/svm: do nested vmexit in nested_svm_exit_handled
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-11-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-11-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> If this function returns true a nested vmexit is required. Move that
> vmexit into the nested_svm_exit_handled function. This also simplifies
> the handling of nested #pf intercepts in this function.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>   

Acked-by: Alexander Graf <agraf@suse.de>

