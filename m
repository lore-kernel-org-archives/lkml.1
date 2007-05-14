Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbXENKk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbXENKk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbXENKku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:40:50 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:40437 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbXENKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=siPV9YSdP0NulTq63nGr4etNj8CcdO9rSX9hvSldCBMBQ1Jebi5Me295JOZJOQGZ7fl7AJDMq7nQ4DBh/t+FxEFX/XgH1x/h5vF35FkAU6vN+iW+85lmSEjntmJPmo249bVYbyulmaH/Z/QuMLwNde7Ffb4lu6X0bvJoxRJsWj0=
Message-ID: <6bffcb0e0705140340m228e8e62n5053db88deadf5fd@mail.gmail.com>
Date: Mon, 14 May 2007 12:40:48 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Barry Scott" <barry.scott@onelan.co.uk>
Subject: Re: Opss: 2.6.21-1.3116.ONELAN Kernel last sysfs file: /class/vc/vcsa7/dev
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46483868.5040106@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46483868.5040106@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Barry,

On 14/05/07, Barry Scott <barry.scott@onelan.co.uk> wrote:
> I'm testing the robustness of Xorg 1.3 server with intel 2.0 driver
> by restarting the X and a set of apps every 30 seconds. After
> about an hour this happened.
>
> 2.6.21-1.3116.ONELAN is the same as 2.6.21-1.3116 from FC7
> but with the spec file change so that we can run the kernel on an FC4
> system.

Ok, it's Fedora 7 kernel, so please visit
https://bugzilla.redhat.com/bugzilla/index.cgi

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
