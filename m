Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZFIIOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZFIIOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZFIIOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:14:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:11362 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZFIIN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cXj5cne7eUyYSIkCuST+dFGxgNGVu2JVvxqeL4UQBsshzjyQlkbar+ZlZjY6cfPuO2
         y2VEl83LZ8qxJCV6Ab+DcFT6LJsLy8wUPtN7pKyrm4cTNoyMbW3i71VRwT4vSFxZwKua
         cbBlh12d4n/iaYtwbOCsKJPuPp3uXBTPaDBTA=
MIME-Version: 1.0
In-Reply-To: <4A2CAC32.5030904@redhat.com>
References: <438397970906072249pe76fafdj49626f20eea31eab@mail.gmail.com>
	 <4A2CAC32.5030904@redhat.com>
Date: Tue, 9 Jun 2009 01:14:00 -0700
Message-ID: <438397970906090114m7ebc6e6fub0c6085f462d2e1a@mail.gmail.com>
Subject: Re: looking for ideas on VM related research projects
From: Kallol Biswas <nucleodyne@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I am from IO and driver background, and not up to date with
current VM developments in linux.

Are you talking about NUMA architecture? Could you clarify or point me
to document that describes the problem with VMA/task affinity? Where
do affinity issues arise?


Kallol

On Sun, Jun 7, 2009 at 11:14 PM, Avi Kivity<avi@redhat.com> wrote:
> Kallol Biswas wrote:
>>
>> Hi,
>>   I have a strong team of good, energetic and young kernel engineers
>> and research scholar and I am looking for ideas on linux virtual
>> memory related research projects for them.
>>
>> Any input or pointers on future virtual memory projects will be
>> appreciated.
>>
>>
>
> - automatically using and breaking up large pages
> - task/vma affinity
> - automatically migrating memory when thread/vma affinity cannot be
> satisfied
>
> --
> Do not meddle in the internals of kernels, for they are subtle and quick to
> panic.
>
>
