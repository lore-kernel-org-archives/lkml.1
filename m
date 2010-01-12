Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110Ab0ALGTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0ALGTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012Ab0ALGTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:19:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:44438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0ALGTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:19:43 -0500
Message-ID: <4B4C15CC.7090803@kernel.org>
Date: Tue, 12 Jan 2010 15:25:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 5/7] driver core: Use sysfs_rename_link in device_rename
References: <m1d41g9z3q.fsf@fess.ebiederm.org> <1263241315-19499-5-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1263241315-19499-5-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Jan 2010 06:19:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 05:21 AM, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Don't open code the renaming of symlinks in sysfs
> instead use the new helper function sysfs_rename_link
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
