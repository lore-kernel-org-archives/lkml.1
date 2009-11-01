Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZKAPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZKAPNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZKAPNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:13:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZKAPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:13:19 -0500
Message-ID: <4AEDA55C.8000500@redhat.com>
Date: Sun, 01 Nov 2009 10:12:28 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic
 and unify it
References: <20091101234614.F401.A69D9226@jp.fujitsu.com> <20091102000855.F404.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091102000855.F404.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 10:09 AM, KOSAKI Motohiro wrote:

> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Rafael J. Wysocki<rjw@sisk.pl>
> Cc: Rik van Riel<riel@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
