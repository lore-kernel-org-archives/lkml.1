Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYDISIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYDISIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYDISIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:08:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:9026 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbYDISIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:08:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BmdLpIsMyOl8DYw9ybXiUVMStCQddmhmoLRkCJXwT8XTOHCKqqBM36NT5GlL1xJPQ5Vb8YZIP32axBiz4tDJUpBMaxogVDlfMGlsVEd5PNXXnpp+lW4vI1jlq+VsCz1iph02Aq3nalesNI6KDv2/uRUXoctQMK0kxv3o8ZEgMKQ=
Message-ID: <cf40c6a90804091108v522bd757nb81e9f97fdc132fc@mail.gmail.com>
Date: Wed, 9 Apr 2008 20:08:19 +0200
From: "Andreas Grimm" <agrimm61@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: VM - a plenty of inactive memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2f11576a0804090801s49587b26h115e8e1760ec7671@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	 <874pabrx6b.fsf@saeurebad.de>
	 <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
	 <2f11576a0804090801s49587b26h115e8e1760ec7671@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki,

>  # echo 3 > /proc/sys/vm/drop_caches
>
that frees exactly the 1,5Gigs in the buffers and the cache. Inactive
memory is still at 25GB.
Any other hint?

Andreas
