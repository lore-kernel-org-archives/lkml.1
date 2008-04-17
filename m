Return-Path: <linux-kernel-owner+w=401wt.eu-S934669AbYDQQtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669AbYDQQtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764172AbYDQQti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:49:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:34958 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760764AbYDQQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZTTWcoaCx8/tJHv+fZ2B5P/zJvi+s00KJ5/YY+GAxeM/EjWwrVC6Wu4D5fRvpoV9V6XA0Y0Q9ew2jlSSXCgHlzWAseQK0s3UbKr8PEa4iA+ek7PkZdEpZfRknmb6bqC4KRCx+o6jEi8i3LFQJneNJ2FOkO2+U92MBWcgJVNqkho=
Message-ID: <e2e108260804170949p6cceb4em78455d8dc5ff7261@mail.gmail.com>
Date: Thu, 17 Apr 2008 18:49:36 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       "Chris Wright" <chrisw@sous-sol.org>
Subject: Re: 2.6.25 section mismatches
Cc: rufus-azrael@numericable.fr
In-Reply-To: <e2e108260804170246i673a2e08q333eeae48467ed4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260804170246i673a2e08q333eeae48467ed4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 11:46 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> Apparently there is a significant number of section mismatches in the
>  2.6.25 kernel. These were already reported against 2.6.25-rc1 and are
>  still present in the final 2.6.25 release. These section mismatches
>  show up at least on the i386 and x86_64 architectures. Maybe it's a
>  good idea before a patch is merged not only to check whether the patch
>  applies cleanly but also to check whether it doesn't create any new
>  section mismatches ?
>
>  See also http://bugzilla.kernel.org/show_bug.cgi?id=9974.

Who should look into this ?

Bart.
