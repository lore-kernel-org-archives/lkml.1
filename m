Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbXIBXsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbXIBXsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 19:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXIBXrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 19:47:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:15513 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXIBXrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 19:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=naMK2sdAJyxGodSwd1/yRBT+CCGkdGU+BZgA53I8ZFjW2AlhN2K3NCxXVKNzorOiSCxdH7x1REze8FJhkh4DGHqKHVhMYapaM0OyJdq617jyRIp9u5OjIGk8ynd4olNDwh0voRgAKwoPY8t6idzj1N0hRAuJzPF6kOpIPljBJyA=
Message-ID: <6bffcb0e0709021647m7ad694d7mf876bf4a6c8b4aca@mail.gmail.com>
Date: Mon, 3 Sep 2007 01:47:50 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Alex Smith" <lkml@alex-smith.me.uk>
Subject: Re: Oops in pwc v4l driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a0738740709020457n3490ee52l49d29712f3ddbb75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a0738740709020457n3490ee52l49d29712f3ddbb75@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 02/09/07, Alex Smith <lkml@alex-smith.me.uk> wrote:
> Hi,
>
> I found an old Philips Askey VC010 webcam and attempted to get it
> working on Linux (latest git, x86_64).

Is this a regression? Does 2.6.22 work fine?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
