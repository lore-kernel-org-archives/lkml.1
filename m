Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXKHSwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXKHSwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759873AbXKHSwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:52:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:32402 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbXKHSwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:52:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rt3z9zlIgL8Bj/XXti9WnnAhDXfBTUVUGJvCUvLTmCadFQ/eBYmGkC8i+jWM5xzzdDwYc0BXFc5NQXArzRbJOdyw6fs3CnydxdqmgCHbQP+4+3zMMdMaftmtpwetqCmHhnaB/Hiu0k3YoO4ArXFunb3OHaV87JcEbtHCixQtP1I=
Message-ID: <8bd0f97a0711081052l7bae8e2v5338180c932c8b4e@mail.gmail.com>
Date: Thu, 8 Nov 2007 13:52:35 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: "dead" CONFIG variables under the include/ directory
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711080906400.29450@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711080906400.29450@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 8, 2007 9:09 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>  asm-blackfin
>     FLASH_SPEED_BHT
>     MEM_MT46V32M16
>     MEM_MT48LC16M8A2TG_75

these are and they arent ... the file they're found in is slated for
tossing (after rewriting the functionality it provides), so until then
it'll just sit
-mike
