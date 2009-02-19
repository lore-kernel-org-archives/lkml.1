Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZBSSMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZBSSMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZBSSMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:12:19 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:62029 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbZBSSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M8hOAES4Zl4wFg3bMWIUyllIAlX20km2S1zaWrvvf/3H9YjgtPTIlMCB4HmAb9EX3F
         spGVOe4Da3CgZDJw/jiNKHmmq8xsHdocf9WMIwFeNYUrWUL6GkKgYr37ZU8/8/03w4vQ
         tpDsStkdPwSDOWHkoPM6x+oxfReWG8iWM88ww=
MIME-Version: 1.0
In-Reply-To: <499D93F0.2090803@oracle.com>
References: <20090220002832.cad00fcd.sfr@canb.auug.org.au>
	 <499D93F0.2090803@oracle.com>
Date: Thu, 19 Feb 2009 19:12:15 +0100
Message-ID: <71cd59b00902191012k764bab32n85f54fc049e35035@mail.gmail.com>
Subject: Re: [PATCH -next] eeepc: needs to depend on INPUT
From: Corentin Chary <corentin.chary@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> EEEPC_LAPTOP needs to depend on INPUT to fix build errors that
> can happen when EEEPC_LAPTOP=y and INPUT=m:

There is already a patch sent to linux-acpi and Len Brown.

http://patchwork.kernel.org/patch/7354/

-- 
Corentin Chary
http://xf.iksaif.net
