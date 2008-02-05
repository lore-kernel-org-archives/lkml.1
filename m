Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYBEFca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYBEFca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYBEFcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:32:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:54134 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYBEFcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=x1zxXFMeqiMbmx3wqn+ZrHtULPBumhRC/x8F9k59fFwZc5Xt3BmPw02jbkGijuFxMp9v7glG/mvX8Ax2qFk17h85bnSwbUbl3I4E45hI3I/T2uXRPCd1Rq/s5lS0XnhDYeoPtq7AbXENG7jx9qEHLzCzMhm0mBsQNqT3LTwaX5o=
Message-ID: <47A7F4DB.3070406@gmail.com>
Date: Tue, 05 Feb 2008 12:32:11 +0700
From: Igor M Podlesny <for.poige+linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071205 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>
Subject: > You may find that you need to update your lvm userspace tools.
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>	<20080202235103.20dd9768.akpm@linux-foundation.org>	<47A71040.5000300@gmail.com> <20080204052709.12f4e0d3.akpm@linux-foundation.org>
In-Reply-To: <20080204052709.12f4e0d3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-02-04 20:27, Andrew Morton wrote:
> On Mon, 04 Feb 2008 20:16:48 +0700 Igor M Podlesny <for.poige+linux@gmail.com> wrote:
[...]
>>    Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any
>> of mine LVM-2 disks. pvscan, for e.g., finds nothing at all.
> 
> You may find that you need to update your lvm userspace tools.

	You're right; I've updated my initrd with fresh lvm
userspace-counterpart and now the problem has been fixed. Sorry for
groundless alert.

	Thanks!

-- 
End of message. Next message?
