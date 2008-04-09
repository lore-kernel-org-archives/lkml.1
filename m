Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYDIVCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYDIVCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYDIVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:02:26 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:65085 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbYDIVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=apS/B0OlscZNYuprrnUt4RPmT/NNmSW+tOJ+bWQdOhY0UjEEQnd+S1TkZVLZyNimMQHu8qSPVDGb4t6+LUyOkqkICEbSSt8OtJ80xYnCLK9GgLh2HujROAMgYRtRfGzK8YmxVBQ5Bfbff6KpfHw6hh2bO4D6/NdljT97h6C38SM=
Message-ID: <36ca99e90804091402i40679876j4f50a4c2f26b3946@mail.gmail.com>
Date: Wed, 9 Apr 2008 23:02:22 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Cc: "Greg KH" <gregkh@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47FD2E3B.5010801@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
	 <20080409203909.GA17183@suse.de> <47FD2E3B.5010801@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 10:59 PM, Mike Travis <travis@sgi.com> wrote:
>  Btw, where does one value per file come from?  I see outputs like:
>
>  # cat /proc/self/stat
>  4313 (cat) R 4218 4313 4218 34816 4313 4194304 207 0 0 0 0 0 0 0 20 0 1 0 6802916 5672960 131 18446744073709551615 4194304 4212948 140735962676160 18446744073709551615 140499600349840 0 0 0 0 0 0 0 17 3 0 0 0 0 0
This isn't sysfs.

Bert
>
>  Thanks,
>  Mike
>
