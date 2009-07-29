Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZG2N5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZG2N5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZG2N5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:57:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:43391 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbZG2N5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:57:00 -0400
Message-ID: <4A70552B.7010608@suse.de>
Date: Wed, 29 Jul 2009 15:56:59 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] kvm/svm: consolidate nested_svm_exit_handled
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-10-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-10-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> When caching guest intercepts there is no need anymore for the
> nested_svm_exit_handled_real function. So move its code into
> nested_svm_exit_handled.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>   

Acked-by: Alexander Graf <agraf@suse.de>


