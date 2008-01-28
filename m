Return-Path: <linux-kernel-owner+w=401wt.eu-S1763436AbYA1WUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763436AbYA1WUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYA1WNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:13:07 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:42965 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762325AbYA1WNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VP2uPBMYAjQGGwRribLcNh4lDZX2b0EuTsfJyZoODe10xmE1FFZJkPt8Y8wcVkM8/LDmN/h3a88wfHTUg7Q/9O/59hJOwPwhbTTLI+sDzedx9QhRNWSvKX8+4vZR7VvUrUBpXxEUEYfyZ1lAIzy2glVJmKAy0haBF0gUsQvx3G4=
Message-ID: <e8ca35370801281412u3ba8f1b9k5024e0ce59f93599@mail.gmail.com>
Date: Mon, 28 Jan 2008 23:12:58 +0100
From: "Pascal Terjan" <pterjan@gmail.com>
To: "Gerardo Exequiel Pozzi" <djgera@gmail.com>
Subject: Re: chars > 0xa0 not displayed in console since 2.6.24
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <479E5082.50208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479E5082.50208@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 11:00 PM, Gerardo Exequiel Pozzi <djgera@gmail.com> wrote:
> Hello,
Hello,

> Chars are displayed OK in kernels < 2.6.24 (2.6.22.16, 2.6.23.14) with
> the same config.
> I booted clean with init=/bin/bash to discard distro (slackware-current)
> problem/incompat, but the problem persist.
>
> This is a know problem?

I think this is because the console is now by default in UTF-8 mode.

> The dmesg and config are attached.

hmm no :)
