Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXLMOQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXLMOQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXLMOQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:16:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:63374 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXLMOQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UIVInMOI5GlBXuxexPHH2jVWHkXAzO6qHyCbiiynYo1SxmZx+liAImrKzpMZ6A6ywTRXgGWCV8TgV7WRPOVrAPhzBztAZl9Br2MFFnzIgUFvG+q0q1AXoFmBRryqc10hpLn+/h9VBh+2aLXpl7DH4iQnvLSIPEQ8t1ZkOvAC9Mk=
Message-ID: <3d8471ca0712130616w4a34b53bs2faafb159df17510@mail.gmail.com>
Date: Thu, 13 Dec 2007 15:16:27 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: separate objdir Makefile regression in 2.6.24-rc*
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071213134841.GA25103@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213134841.GA25103@basil.nowhere.org>
X-Google-Sender-Auth: ea942017514e5592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 2:48 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> 2.6.24-rc5 doesn't seem to create Makefiles in empty obj dirs anymore

Known problem ;-)
See http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/188cbd12d7c0871b/194fbc7c94314b2c

-- 
Guillaume
