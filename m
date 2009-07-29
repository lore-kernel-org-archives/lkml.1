Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZG2OUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZG2OUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZG2OUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:20:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:44309 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZG2OUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:20:36 -0400
Message-ID: <4A705AB4.90103@suse.de>
Date: Wed, 29 Jul 2009 16:20:36 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] kvm/svm: handle #pf intercepts in nested_svm_exit_handled
 directly
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-12-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-12-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Alexander Graf <agraf@suse.de>

I'm really starting to miss comments on the commits ...
