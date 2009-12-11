Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbZLKLSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbZLKLSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZLKLS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:18:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48292 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZLKLS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:18:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=erboBjlK117Snb9zOB7LJErQ9f7W1WOEIck6CiKUduRbBbifKEmHw1UbaRLhuOY69Q
         0hyVKdcwtQ9b4Zfip/ZJILJF8Br70gru3L5pTNa3OZiaFGwkYxKCvwLGg6ru/OrPKgCO
         2IBgmxruJCkmCaglsbi19k6f/j378WxbG0dXc=
Date: Fri, 11 Dec 2009 12:18:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH] tracing: add checks for printing graph irq
Message-ID: <20091211111829.GB5244@nowhere>
References: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:38:35PM +0800, Wenji Huang wrote:
> Check return value of trace_seq_printf.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---


Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

