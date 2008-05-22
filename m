Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYEVRu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYEVRu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYEVRuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:50:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31519 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbYEVRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H7/ka/1HeHPqkp1x6YgBYugajfXInnx/fETUuWQNeCYlVjbDw8LobrNOI2nQtsatcQdD4JF4jvnMk472NOz/fXS/D16PQ/MBGRbBOTWjRIWD6Bcdtz450ph0d63qslHfUsQdXhBFnCw9GqavcTGLmBeyWfrNUGD/tpTiRHtPH3E=
Message-ID: <e2e108260805221050s3ee280an8155898c216c334c@mail.gmail.com>
Date: Thu, 22 May 2008 19:50:08 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: section mismatch warnings in current git head for powerpc
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <4835ABDB.8020901@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4835ABDB.8020901@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 7:22 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> I got the following warnings when building current git head for powerpc
> 64bit:

Something that should be fixed, but not something to worry about.
Similar warnings appear when building the kernel for x86_64. See also
http://lkml.org/lkml/2008/4/13/98, http://lkml.org/lkml/2008/4/17/202
and http://bugzilla.kernel.org/show_bug.cgi?id=9974.

Bart.
