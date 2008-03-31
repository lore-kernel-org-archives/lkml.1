Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYCaQMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYCaQMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYCaQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:12:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:18803 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYCaQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RPuLKcJN2IakmcFgGCX1aicpJFdmo74lVJEnxyV2XArsuNIXuDeeIXNU7enDOYcIxZ6ff0mHNRitSgtMeDmnPG65wxJs11uhLgxzWgayXzigUaMPBhCjkI6x38ua5afmWmX5VjT6aOFqVDFv8yPYR7KCeW4oszIqYNFCBkOwufE=
Message-ID: <e2e108260803310912t43f16807qc59dd4f543d676c6@mail.gmail.com>
Date: Mon, 31 Mar 2008 18:12:04 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Marc Perkel" <mperkel@yahoo.com>
Subject: Re: Kernel oops [11]
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <287652.54624.qm@web52505.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <287652.54624.qm@web52505.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 5:45 PM, Marc Perkel <mperkel@yahoo.com> wrote:
>  What is kernel oops [11]? It seems to have started
>  after I turned on "cool and quiet" in the AMD MB Bios.

Please upgrade your BIOS. A flaky BIOS can make your system crash when
frequency scaling / cool and quiet / speedstep technology is enabled.

Bart.
