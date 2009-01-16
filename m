Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbZAPMvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbZAPMvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbZAPMuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:50:52 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:17807 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434AbZAPMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VFth1lf0ezoPv1wL8qHTLZCcQC/cSqq4Qm2XSqb5l/La9xmy3UecWfl6S2Glywpvxe
         4sk+lsg8sLM8duzoi3Pw8VPDBUv+hBs6uv2ikgJMBYwOyoXBlGd7NzEl4jlGgRiICokd
         /2+H2mdlz+EI3sQT6vrLABiUmdZgPXa9P19zM=
Message-ID: <21d34cad0901160450n707e9853x6dfdb1b148a75ed2@mail.gmail.com>
Date: Fri, 16 Jan 2009 20:50:48 +0800
From: "Qinghuang Feng" <qhfeng.kernel@gmail.com>
To: chris.mason@oracle.com
Subject: Re: [PATCH] Btrfs: simplify iteration codes
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <49703687.044e6e0a.04fa.257b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49703687.044e6e0a.04fa.257b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 3:25 PM, Qinghuang Feng <qhfeng.kernel@gmail.com> wrote:
> merge list_for_each and list_entry to list_for_each_entry.
>
Please ignore this patch, I will resend a patch to cleanup all the
similar codes in btrfs.
