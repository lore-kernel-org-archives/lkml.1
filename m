Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYCZLQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYCZLQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYCZLQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:16:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:18551 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYCZLP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G6FZjnioYWpG4gfMaVKObwo5YF0sKBJUcaWDxTfQIz8nbzuiUnEJaZIjFtFRkfPWg7q0wa2DKF7V6ww9no0bBLKmLoqXcwZ8zCG0Y6scZkKZUpIkpZRL6V/DibNoHOFfOe5DdGvWadjg2VMzPimEvOuX2gzfytARiVpufsy6xHA=
Message-ID: <e2e108260803260415w64fa4feave44560dd7ac7cbdb@mail.gmail.com>
Date: Wed, 26 Mar 2008 12:15:57 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Emmanuel Florac" <eflorac@intellique.com>
Subject: Re: RAID-1 performance under 2.4 and 2.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080326120713.24cb8093@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080325194306.4ac71ff2@galadriel.home>
	 <e2e108260803260142o34c33e7ajf395d5cb62824cb4@mail.gmail.com>
	 <20080326120713.24cb8093@harpe.intellique.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 12:07 PM, Emmanuel Florac
<eflorac@intellique.com> wrote:
> Le Wed, 26 Mar 2008 09:42:19 +0100
>  "Bart Van Assche" <bart.vanassche@gmail.com> écrivait:
>
>  > Keep in mind that the above test tests two subsystems at the same
>  > time: RAID-1 + the filesystem on top of it.
>
>  I'm using XFS usually, and I've also checked against the raw devices
>  and it looks the same (2.4 still faster). I must add that the difference
>  is somewhat reduced when using a single disk drive vs. RAID-1,
>  obviously due to different buffering policy in the RAID subsystem.

You are welcome to post the numbers you obtained with dd for direct
I/O on a RAID-1 setup for 2.4 versus 2.6 kernel.

Bart.
