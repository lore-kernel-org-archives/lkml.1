Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbYAKIwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbYAKIwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYAKIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:52:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:58776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbYAKIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=wxrZo2vnHRZnx3WmMZS486xLMYg8+3JU2rB3USroMvOfCnXGRR0T1pHm/xsZbNwnyzMu+tAl1G0Ced754tx42qXrugHyWdcWuNF8OiGur+KX3WsgPfduw03Ay526alEcyMvHJMfFVD6Gd1RdMHFoPZIEXG0rAmJNACa75M2uFL0=
Message-ID: <47872E35.3070705@gmail.com>
Date: Fri, 11 Jan 2008 09:52:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: apw@shadowen.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch.pl: allow piping
References: <20080111041120.085610726@mvista.com>
In-Reply-To: <20080111041120.085610726@mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 05:10 AM, Daniel Walker wrote:
> A little feature addition to allow checkpatch.pl to check patches piped
> into it, in addition to specific file arguments.

You can still add - as an argument to check stdin. In which way is this better?

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
