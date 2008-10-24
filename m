Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYJXRxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYJXRxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYJXRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:53:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:51173 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJXRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fJUe6zcesZ+Chg+OmhuSaITQ4j2+wfSF1Qf1nmlK0IL6BZl6WNyazH6xvm7VsSsGNK
         jmfDpK/7WcGXHGpcb/zbksbqSPifMtJzZ1S40tph7MS0IgON8BpwxReDgW6heUjJGeZc
         LGRDlh3Ln7w0girgBCr0xaMn9T4Zto/3Wmkek=
Message-ID: <e9c3a7c20810241053t2f991a62p1d03fb60f8750a89@mail.gmail.com>
Date: Fri, 24 Oct 2008 10:53:21 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Fix compile warning CONFIG_I7300_IDLE_IOAT_CHANNEL not defined
Cc: "Len Brown" <lenb@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
In-Reply-To: <20081023223906.GA26918@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023223906.GA26918@linux-os.sc.intel.com>
X-Google-Sender-Auth: 5d160598d51cfa50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 3:39 PM, Venki Pallipadi
<venkatesh.pallipadi@intel.com> wrote:
>
> When I7300_idle driver is not configured, there is a compile time
> warning about IDLE_IOAT_CHANNEL not defined. Fix it.
>

Please copy Maciej and myself on ioat changes.

Thanks,
Dan
