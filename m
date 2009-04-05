Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZDEL34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZDEL34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 07:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZDEL3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 07:29:43 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58611 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZDEL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fzHuwIege/Sm/hyH7H73zAKx3D1plRVgv0hg4x0jwDiGgnatr3RZiq3+7t3D21wPLs
         Z8hOSG+quyTqS5MKtjCnBSIzsh+MMXiLbqmAReKjbssyFgkVD2wctWIBBqT4Bt1H4SvP
         MDCGGdOBzubhq99jaSgyCZgRngWlqp28mjOmg=
MIME-Version: 1.0
In-Reply-To: <49D7B122.50103@wpkg.org>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org>
Date: Sun, 5 Apr 2009 13:29:38 +0200
Message-ID: <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between 
	different SCSI targets (SCST, STGT, IET, LIO)
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 4, 2009 at 9:12 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> I made some simple SCST and STGT tests last week, there were some where SCST
> won, there were some where STGT won.

Hello Tomasz,

It would be great if you could publish the details of your setup and
the tests you have run, such that we are able to reproduce the tests
and analyze the results further.

Bart.
