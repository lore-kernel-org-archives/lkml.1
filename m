Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZKBTF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZKBTF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZKBTF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:05:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbZKBTF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:05:26 -0500
Message-ID: <4AEF2D78.5060607@redhat.com>
Date: Mon, 02 Nov 2009 14:05:28 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] Add get_user_pages() variant that fails if major
 fault is required.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-6-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-6-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 06:56 AM, Gleb Natapov wrote:
> This patch add get_user_pages() variant that only succeeds if getting
> a reference to a page doesn't require major fault.
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
