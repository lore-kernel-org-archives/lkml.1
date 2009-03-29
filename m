Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZC2NA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZC2NA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZC2NAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:00:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZC2NAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:00:12 -0400
Message-ID: <49CF70D6.4070906@redhat.com>
Date: Sun, 29 Mar 2009 16:00:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] kvm x86: report 1GB page support to userspace
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-8-git-send-email-joerg.roedel@amd.com> <49CF6177.9010907@redhat.com> <20090329124548.GG31080@8bytes.org> <49CF6E47.3050402@redhat.com> <20090329125447.GJ31080@8bytes.org>
In-Reply-To: <20090329125447.GJ31080@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Ok I will change that together with the page_size -> page_level
> chhanges. But I doubt that there will ever be 0.5T pages ;)
>   

We're bloating at a rate of 1 bit per 1-2 years, so we have 8-16 years 
to prepare.

-- 
error compiling committee.c: too many arguments to function

