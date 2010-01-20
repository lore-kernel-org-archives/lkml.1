Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760Ab0ATJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab0ATJUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490Ab0ATJUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:20:09 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:62978 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0ATJUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:20:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Tmw4fUQRQP65QoBxXzMAuxV9z4812PtwFLOlcD8ilAnxBFFvQLhhzBBEGXWtlLDpUL
         WViw11kkHeVoWEWf1PedZAjXvb9oxR5a461617usQaxxJAP7D+beM7ok1kIvaE6sl4Du
         Dm749TDN7NuyCYZS97lD+Skr/zMrJr4AED5fI=
MIME-Version: 1.0
In-Reply-To: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com>
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com>
Date: Wed, 20 Jan 2010 17:20:00 +0800
Message-ID: <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com>
Subject: About ACL for IPC Object
From: zhou peng <ailvpeng25@gmail.com>
To: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There are ACL in file system, but why there are no ACL implementation
in IPC object, eg. shm, message queue, FIFO?
Is there any fine grained granting in ipc object just like in file object?

Thanks,
Best

--
zhoupeng
