Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZG2NB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZG2NB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZG2NBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:01:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbZG2NBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:01:54 -0400
Message-ID: <4A70495C.8040308@redhat.com>
Date: Wed, 29 Jul 2009 16:06:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] Nested SVM cleanups
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 03:56 PM, Joerg Roedel wrote:
> Hi,
>
> here is a first round of patches to clean up the code for SVM virtualization
> for KVM on AMD. There is more to clean up but since I am on vacation the rest
> of the week here is what I have queued up so far. Maybe this saves me from
> rebasing this code next week ;-)
> I tested these patches with KVM in KVM and it works stable with and without
> nested SMP. It doesn't seem to break anything.
>    

Alex, I'd appreciate a review of this.

-- 
error compiling committee.c: too many arguments to function

