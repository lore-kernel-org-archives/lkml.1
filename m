Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbYBZOHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbYBZOHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYBZOHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:07:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:58411 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbYBZOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GUUu4TWQmxMAqylsEMhPKkgM3YWFmAOx3zt+I2MzLJpIY6/ppCJB7xclGkY3PyNRKv0pPX8qUSstVa+FBjytnpdXBuhmvMoVbw52rGHlabkw7VRKMSUV0C6euc/lhCjR6YsF5uYdqpmFMNpAn7A3VuzgIGt5mkpdvF1yh2qp77g=
Message-ID: <84144f020802260607h3c8a5b50w9f005b76b1ff8087@mail.gmail.com>
Date: Tue, 26 Feb 2008 16:07:42 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: ohyama_sec@ariel-networks.com
Subject: Re: [PATCH] I found a type miss in fs/ext2/ext2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080226102415.DA893948006@ns.ariel-networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080226102415.DA893948006@ns.ariel-networks.com>
X-Google-Sender-Auth: 0927b59207cdfc84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 12:24 PM,  <ohyama_sec@ariel-networks.com> wrote:
>  Maybe I found a type miss in fs/ext2/ext2.h which is in linux-2.6.24.3, and write difference below.

You probably want to read Documentation/SubmittingPatches first and
re-send the patch in the proper format.

                     Pekka
