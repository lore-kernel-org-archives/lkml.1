Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYDCJ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYDCJ2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYDCJ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:28:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:20482 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbYDCJ2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:28:43 -0400
Message-ID: <9ea470500804030228p3077456ai4a756aa46116aa4c@mail.gmail.com>
Date: Thu, 3 Apr 2008 11:28:42 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: Xavier <x.guimard@free.fr>
Subject: Re: Proposed patch for IDE missing commands
Cc: linux-kernel@vger.kernel.org,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
In-Reply-To: <47F47324.80108@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <47F47324.80108@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Bart, linux-ide to CC:)

Hi,

On Thu, Apr 3, 2008 at 8:03 AM, Xavier <x.guimard@free.fr> wrote:
> Hi all,
>
>  I'm working for the french Gendarmerie Nationale and we've decided to
> publish our patch for the kernel that provides some missing IDE commands to
> access to protected areas (HPA and DCO).
>
>  Best regards,
>  Xavier
>

Please, rebase/redo your patch against latest -rc kernel (in this case
2.6.25-rc8) und run it through
scripts/checkpatch.pl in order to adjust it to the kernel coding
style. See Documentation/CodingStyle
for details.

Thanks.

-- 
Regards/Gruﬂ,
Boris
