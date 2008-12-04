Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYLDLgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYLDLgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYLDLgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:36:35 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:43958 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYLDLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M7Id3NYIwzP908jBdjDTk3DTvVaYI/XzfNJiskX/KFsROiQd+ETLcEpnDt7gz1Fu88
         Q3l3FXLzMIOointNFuSTIF3h8CxrfSqC3M0oupq/qVvJkozWZ3cRdezYoPfsHd/NCMNG
         sVGoxNzbB2T5N4RCERk+EUUlt3y5tqicjZgF0=
Message-ID: <2375c9f90812040336r498cfefbta51b2ae2689a3d5f@mail.gmail.com>
Date: Thu, 4 Dec 2008 11:36:33 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Jianjun Kong" <jianjun@zeuux.org>
Subject: Re: [PATCH 2/3] fix warning of not used variable
Cc: rusty@rustcorp.com.au,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081204010022.GB17445@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081204010022.GB17445@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 1:00 AM, Jianjun Kong <jianjun@zeuux.org> wrote:
>
> fix this warning:
> kernel/module.c:824: warning: 'print_unload_info' defined but not used
> print_unload_info() just used when CONFIG_PROC_FS was defined.
>
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>


Reviewed-by: WANG Cong <wangcong@zeuux.org>


Rusty?
