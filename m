Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZLNOev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZLNOev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZLNOeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:34:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZLNOet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:34:49 -0500
Message-ID: <4B264CE0.1060604@redhat.com>
Date: Mon, 14 Dec 2009 09:34:08 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [cleanup][PATCH 1/8] vmscan: Make shrink_zone_begin/end helper
 function
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com> <20091214212308.BBB1.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091214212308.BBB1.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 07:23 AM, KOSAKI Motohiro wrote:
> concurrent_reclaimers limitation related code made mess to shrink_zone.
> To introduce helper function increase readability.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
